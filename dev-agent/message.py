# coding: utf-8

from typing import Any, Dict, List

import tiktoken


class LlmMessageContainer:
    def __init__(self):
        self.messages = []
        self.metas = []
        self.token_encoder = tiktoken.get_encoding("cl100k_base")

    def add_system_message(self, content: str) -> None:
        self.metas.append({
            "index": len(self.metas),
            "token": len(self.token_encoder.encode(content)),
            "role": "system"
        })
        self.messages.append({"role": "system", "content": content})

    def add_user_message(self, content: str) -> None:
        self.metas.append({
            "index": len(self.metas),
            "token": len(self.token_encoder.encode(content)),
            "role": "user"
        })
        self.messages.append({"role": "user", "content": content})

    def add_raw_message(self, message: Dict[str, Any]) -> None:
        self.metas.append({
            "index": len(self.metas),
            "token": len(self.token_encoder.encode(message["content"])),
            "role": message["role"]
        })
        self.messages.append(message)

    def total_token(self) -> int:
        return sum(meta["token"] for meta in self.metas)

    def add_raw_messages(self, messages: List[Dict[str, Any]]) -> None:
        for message in messages:
            self.add_raw_message(message)

    def to_capped_messages(self, token_limit: int = 28000) -> List[Dict[str, Any]]:
        if self.total_token() > token_limit:
            system_metas = [
                meta for meta in self.metas if meta["role"] == "system"]
            not_system_metas = [
                meta for meta in self.metas if meta["role"] != "system"]
            current_token = sum(meta["token"] for meta in system_metas)
            filtered_indexes = [meta["index"] for meta in system_metas]

            for meta in reversed(not_system_metas):
                if current_token + meta["token"] > token_limit:
                    break
                current_token += meta["token"]
                filtered_indexes.append(meta["index"])

            system_and_filtered_message = [message for i, message in enumerate(
                self.messages) if i in filtered_indexes]
            return system_and_filtered_message
        else:
            return self.messages

    def add_default_system_message(self) -> None:
        # Replace `Time.current.to_s(:jp_mdw_hm)` with an equivalent Python method to get the current time in the desired format.
        # Here, I'm just using the default string representation of the current datetime.
        from datetime import datetime
        self.add_system_message(f"Current time is {datetime.now()}")

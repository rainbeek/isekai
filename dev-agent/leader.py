# coding: utf-8

from chat import chat_with_function_calling_loop
from function import GetFilesList, ReadFile
from message import LlmMessageContainer


class Leader:
    _actor_name = 'Leader'

    def __init__(self, product_owner_comment: str):
        self._product_owner_comment = product_owner_comment

    def work(self) -> str:
        print('---------------------------------')
        print(f'{self._actor_name}: Start to work')

        with open('leader-prompt.md', encoding='utf-8') as f:
            prompt = f.read()

        message_container = LlmMessageContainer()

        message_container.add_system_message(prompt)

        message_container.add_system_message(
            'The request from the product owner is as follows.\n\n'
            + self._product_owner_comment
            + '\n\n'
        )

        comment = chat_with_function_calling_loop(
            messages=message_container,
            functions=[
                GetFilesList(),
                ReadFile(),
            ],
            actor_name=self._actor_name,
        )

        print(f'{self._actor_name}: {comment}')
        return comment

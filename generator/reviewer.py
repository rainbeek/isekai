# coding: utf-8

from ai import chat_with_function_calling_loop
from function import GetFilesList, ReadFile, RecordLGTM


class Reviewer:
    _actor_name = 'Reviewer'

    def __init__(self, prompt: str):
        self._leader_comment = prompt
        self._record_lgtm = RecordLGTM()

    def work(self, programmer_comment: str) -> str:
        print('---------------------------------')
        print(f'{self._actor_name}: start to work')

        with open('reviewer-prompt.md', encoding='utf-8') as f:
            prompt = f.read()

        system_message = prompt

        system_message += (
            'The request from the engineer leader is as follows.\n\n'
            + self._leader_comment
            + '\n\n'
        )

        if programmer_comment is not None:
            system_message += (
                'The request from the programmer is as follows.\n\n'
                + programmer_comment
                + '\n\n'
            )

        # TODO: 現状の差分をシステムプロンプトに入れておく

        comment = chat_with_function_calling_loop(
            messages=system_message,
            functions=[
                GetFilesList(),
                ReadFile(),
                self._record_lgtm,
            ],
            actor_name=self._actor_name,
        )

        print(f'{self._actor_name}: {comment}')
        return comment

    def lgtm(self) -> bool:
        return self._record_lgtm.lgtm

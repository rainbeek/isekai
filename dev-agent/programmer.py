# coding: utf-8

from chat import chat_with_function_calling_loop
from function import (AnalyzeFlutter, GetFilesList, MakeNewFile, ModifyFile,
                      ReadFile)


class Programmer:
    _actor_name = 'Programmer'

    def __init__(self, prompt: str):
        self._leader_comment = prompt

    def work(self, reviewer_comment: str) -> str:
        print('---------------------------------')
        print(f'{self._actor_name}: Start to work')

        with open('programmer-prompt.md', encoding='utf-8') as f:
            prompt = f.read()

        system_message = prompt

        system_message += (
            'The request from the engineer leader is as follows.\n\n'
            + self._leader_comment
            + '\n\n'
        )

        if reviewer_comment is not None:
            system_message += (
                'The request from the reviewer is as follows.\n\n'
                + reviewer_comment
                + '\n\n'
            )

        # TODO: 現状の差分をシステムプロンプトに入れておく

        comment = chat_with_function_calling_loop(
            messages=system_message,
            functions=[
                GetFilesList(),
                ReadFile(),
                MakeNewFile(),
                ModifyFile(),
                AnalyzeFlutter(),
            ],
            actor_name=self._actor_name,
        )

        print(f'{self._actor_name}: {comment}')
        return comment

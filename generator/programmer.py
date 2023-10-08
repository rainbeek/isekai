# coding: utf-8

from ai import chat_with_function_calling_loop
from function import GetFilesList, ModifyFile, ReadFile


class Programmer:
    _actor_name = 'Programmer'

    def __init__(self, prompt: str):
        self._leader_comment = prompt

    def work(self, reviewer_comment: str) -> str:
        print('---------------------------------')
        print(f'{self._actor_name}: start to work')

        system_message = (
            "You are an excellent Flutter programmer. \n" +
            "Please make appropriate modifications to this repository using functions based on instructions from engineer leader.\n" +
            "You are responsible for determining program policies themselves.\n" +
            "When implementing the test code, imagine the specification from the implementation of the target class and concretely implement the test case.\n" +
            "When modifying a file, read_file first and indent properly.\n" +
            "You are the only programmer. Don't raise the issue with the reviewer while there is a problem;" +
            "solve the problem before responding to the reviewer.\n" +
            "After making the corrections, please inform the reviewer of your concerns in japanese.\n" +
            "The request from the engineer leader is as follows.\n\n" + self._leader_comment
        )

        if reviewer_comment is not None:
            system_message += "The request from the reviewer is as follows.\n\n" + reviewer_comment

        # TODO: 現状の差分をシステムプロンプトに入れておく

        comment = chat_with_function_calling_loop(
            messages=system_message,
            functions=[
                GetFilesList(),
                ReadFile(),
                ModifyFile(),
            ],
            actor_name=self._actor_name,
        )

        print(f'{self._actor_name}: {comment}')
        return comment

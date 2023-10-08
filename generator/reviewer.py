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

        system_message = (
            "You are an excellent Flutter program reviewer. \n" +
            "We review and thoroughly check the modifications made by programmers in response to requests from engineer leader, " +
            "and identify any points that require additional attention and point them out to programmers in japanese.\n" +
            "Once all checks have been completed and there are no issues found, ensure you execute the RecordLGTM function.\n" +
            "When reviewing, please pay particular attention to the following points:\n" +
            "- The revised code should have a natural design, with readable code that utilizes appropriate and understandable variable names.\n" +
            "The request from the engineer leader is as follows.\n\n" + self._leader_comment
        )

        if programmer_comment is not None:
            system_message += "The request from the programmer is as follows.\n\n" + programmer_comment

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

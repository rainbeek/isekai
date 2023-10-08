# coding: utf-8

import json
import os

import openai


def chat_with_function_calling_loop(messages, functions, actor_name: str):
    openai.organization = os.environ.get('OPENAI_ORGANIZATION_ID')
    openai.api_key = os.environ.get('OPENAI_API_KEY')

    iteration = 0
    function_definitions = [function.definition for function in functions]

    while iteration < 30:
        test = messages.to_capped_messages()

        response = openai.ChatCompletion.create(
            # model="gpt-4-0613",
            model="gpt-3.5-turbo-0613",
            messages=messages.to_capped_messages(),
            functions=function_definitions,
            function_call="auto",
        )

        response_message = response["choices"][0]["message"]

        if response_message.get("function_call"):
            function_call = response_message["function_call"]
            function_name = function_call["name"]
            function = [
                function
                for function in functions
                if function.definition['name'] == function_name
            ][0]
            function_arguments = json.loads(function_call["arguments"])

            function_response = function.execute_and_generate_message(
                args=function_arguments
            )

            print(
                f'{actor_name}: Request to call {function_name} with {function_arguments}'
            )

            messages.add_raw_message(response_message)

            messages.add_raw_message({
                "role": "function",
                "name": function_name,
                "content": function_response,
            })

        else:
            break

        iteration += 1

    content = response_message.get('content')
    return content

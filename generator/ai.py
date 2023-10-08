# coding: utf-8

import json
import os

import openai


def chat_with_function_calling_loop(messages, functions, actor_name: str):
    openai.organization = os.environ.get('OPENAI_ORGANIZATION')
    openai.api_key = os.environ.get('OPENAI_TOKEN')

    iteration = 0
    messages = [
        {
            "role": "user",
            "content": f"{messages}",
        }
    ]
    function_definitions = [function.definition for function in functions]

    while iteration < 30:
        response = openai.ChatCompletion.create(
            model="gpt-4-0613",
            messages=messages,
            functions=function_definitions,
            function_call="auto",  # auto is default, but we'll be explicit
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
                args=function_arguments)

            messages.append(response_message)

            messages.append({
                "role": "function",
                "name": function_name,
                "content": function_response,
            })

        else:
            break

        iteration += 1

    content = response_message.get('content')
    return content

# coding: utf-8
import glob
import json
import os


class GetFilesList:
    definition = {
        "name": 'GetFilesList',
        "description": "Get files list",
        "parameters": {
            "type": "object",
            "properties": {},
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        files = glob.glob('../**/*.dart', recursive=True)
        return json.dumps(files)


class ReadFile:
    definition = {
        "name": 'ReadFile',
        "description": "Read file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to read.",
                },
            },
            "required": ["path"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']

        if os.path.exists(path) is True:
            with open(path, encoding='utf-8') as f:
                contents = f.read()

            result_dict = {
                'path': path,
                'contents': contents,
            }
        else:
            result_dict = {
                'path': path,
                'error': 'File not found.',
            }

        return json.dumps(result_dict)


class MakeNewFile:
    definition = {
        "name": 'MakeNewFile',
        "description": "Make new file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to make.",
                },
                "contents": {
                    "type": "string",
                    "description": "File contents to write.",
                },
            },
            "required": ["path", "contents"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']
        contents = args['contents']

        with open(path, 'w', encoding='utf-8') as f:
            f.write(contents)

        return 'Succeeded to make new file.'


class ModifyFile:
    definition = {
        "name": 'ModifyFile',
        "description": "Modify file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to modify.",
                },
                "contents": {
                    "type": "string",
                    "description": "File contents to write.",
                },
            },
            "required": ["path", "contents"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']
        contents = args['contents']

        with open(path, 'w', encoding='utf-8') as f:
            f.write(contents)

        return 'Succeeded to modify file.'


class RecordLGTM:
    definition = {
        "name": 'RecordLGTM',
        "description": "Record LGTM",
        "parameters": {
            "type": "object",
            "properties": {},
        },
    }

    def __init__(self) -> None:
        self.lgtm = False

    def execute_and_generate_message(self, args) -> str:
        self.lgtm = True

        return 'Succeeded to record LGTM.'

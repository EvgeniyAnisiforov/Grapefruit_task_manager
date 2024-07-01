import json
import os


class ConfigDict(dict):
    def __getattr__(self, item):
        return self.get(item, None)


class Config:
    def __init__(self, config_file='config.json'):
        self.config_file = config_file
        self.load_config()

    def load_config(self):
        config_path = os.path.join(os.path.dirname(__file__), '..', self.config_file)
        with open(config_path, 'r') as file:
            config_data = json.load(file)
            self.__dict__.update(self._dict_to_attr(config_data))

    def _dict_to_attr(self, data):
        if isinstance(data, dict):
            return ConfigDict({key: self._dict_to_attr(value) for key, value in data.items()})
        elif isinstance(data, list):
            return [self._dict_to_attr(item) for item in data]
        else:
            return data


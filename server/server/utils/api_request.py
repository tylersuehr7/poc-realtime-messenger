from abc import abstractmethod
from typing import Any, Optional

from rest_framework import serializers
from rest_framework.request import Request


class ApiRequest(serializers.Serializer):
    @classmethod
    @abstractmethod
    def parse(cls, request: Request, path_params: dict = None):
        return NotImplementedError()

    @classmethod
    def _get_payload(cls, data: dict, path_params: dict = None) -> dict:
        cls_instance = cls(data=data)
        cls_instance.is_valid(raise_exception=True)
        return {**cls_instance.validated_data, **path_params} if path_params else cls_instance.validated_data

    @staticmethod
    def _to_bool(data: Any) -> bool:
        """Makes a bool data type from given data"""
        if isinstance(data, str):
            return data == "true"
        elif isinstance(data, bool):
            return data
        return bool(data)

    @classmethod
    def _to_optional_bool(cls, data: Optional[Any]) -> Optional[bool]:
        """Makes an optional bool data type from given optional data"""
        return cls._to_bool(data) if data is not None else None

    def update(self, instance, validated_data):
        pass

    def create(self, validated_data):
        pass

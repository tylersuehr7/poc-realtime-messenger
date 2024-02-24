from dataclasses import dataclass


@dataclass(frozen=True)
class AuthenticateAccountParams:
    username: str
    password: str

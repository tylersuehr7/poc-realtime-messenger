import os
from server import settings

PACKAGE_NAME_PREFIX = "@server"
TYPESCRIPT_LIB_NAME = "server-api-client-ts"
DART_LIB_NAME = "server_api_client_dart"
GENERATED_CLIENT_LIBS_PATH = f"{str(settings.BASE_DIR)}/generated-clients"
GENERATED_TYPESCRIPT_LIB_PATH = f"{GENERATED_CLIENT_LIBS_PATH}/{TYPESCRIPT_LIB_NAME}"
GENERATED_DART_LIB_PATH = f"{GENERATED_CLIENT_LIBS_PATH}/{DART_LIB_NAME}"

generator_configs = {
    "typescript-axios": {
        "lib-name": TYPESCRIPT_LIB_NAME,
        "additional-properties": [
            "supportsES6=true",
            f"npmVersion={settings.VERSION}",
            f"npmName={PACKAGE_NAME_PREFIX}/{TYPESCRIPT_LIB_NAME}",
            f"npmRepository=https://gitlab.com/api/v4/projects/27971994/packages/npm/",
            f"useSingleRequestParameter=true"
        ],
    },
    "dart-dio": {
        "lib-name": DART_LIB_NAME,
        "additional-properties": [
            f"pubAuthor=SuehrSolutions",
            f"pubAuthorEmail=tylersuehr7@yahoo.com",
            f"pubLibrary={DART_LIB_NAME}",
            f"pubName={DART_LIB_NAME}",
            f"pubVersion={settings.VERSION}",
            f"useSingleRequestParameter=true",
            f"dioLibrary=dio_http",
            f"legacyDiscriminatorBehavior=false",
        ],
    },
}


def generate_clients():
    for lang, config in generator_configs.items():
        os.system(f"mkdir -p {GENERATED_CLIENT_LIBS_PATH}/{config['lib-name']}")
        command = f"openapi-generator generate -g {lang} " "--additional-properties="

        for prop in config["additional-properties"]:
            command += f"{prop},"

        command = command[0:-1]
        command += (
            f" -o ./generated-clients/{config['lib-name']}"
            f" -i {str(settings.BASE_DIR)}/schema.yml"
            f" --enable-post-process-file"
        )

        os.system(command)
        print(command)


def build_clients():
    # Build the Flutter dart client
    os.system(
        f"(cd {GENERATED_DART_LIB_PATH} && "
        f"flutter pub get && "
        f"flutter pub upgrade && "
        f"flutter packages pub run build_runner build --delete-conflicting-outputs)"
    )

    # Build the Typescript client
    os.system(
        f"(cd {GENERATED_TYPESCRIPT_LIB_PATH} && npm install)"
    )


def run():
    generate_clients()
    build_clients()
    
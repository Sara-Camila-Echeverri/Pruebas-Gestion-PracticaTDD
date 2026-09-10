import os
import urllib.request
import zipfile

def setup():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tools_dir = os.path.join(root, "tools")
    os.makedirs(tools_dir, exist_ok=True)

    files = [
        ("junit-platform-console-standalone-1.10.2.jar", "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.2/junit-platform-console-standalone-1.10.2.jar"),
        ("junit-4.13.2.jar", "https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar"),
        ("hamcrest-core-1.3.jar", "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar"),
        ("mockito-core-5.11.0.jar", "https://repo1.maven.org/maven2/org/mockito/mockito-core/5.11.0/mockito-core-5.11.0.jar"),
        ("byte-buddy-1.14.12.jar", "https://repo1.maven.org/maven2/net/bytebuddy/byte-buddy/1.14.12/byte-buddy-1.14.12.jar"),
        ("byte-buddy-agent-1.14.12.jar", "https://repo1.maven.org/maven2/net/bytebuddy/byte-buddy-agent/1.14.12/byte-buddy-agent-1.14.12.jar"),
        ("objenesis-3.3.jar", "https://repo1.maven.org/maven2/org/objenesis/objenesis/3.3/objenesis-3.3.jar"),
    ]

    for name, url in files:
        dest = os.path.join(tools_dir, name)
        if not os.path.exists(dest):
            print(f"Descargando {name}...")
            urllib.request.urlretrieve(url, dest)
            print(f"Listo: {name}")

if __name__ == "__main__":
    setup()

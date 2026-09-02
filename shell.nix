{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  }
}:

let
  jdk = pkgs.openjdk17;
in
pkgs.mkShell {
  name = "pink-auto-dev-shell";

  buildInputs = with pkgs; [
    flutter
    dart
    jdk
    git
    unzip
    pkg-config
  ];

  shellHook = ''
    export JAVA_HOME="${jdk.home}"
    
    # Auto-detect local Android SDK path on WSL/Linux if available
    if [ -d "/mnt/c/Users/om29dev/AppData/Local/Android/Sdk" ]; then
      export ANDROID_HOME="/mnt/c/Users/om29dev/AppData/Local/Android/Sdk"
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
      export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
    fi

    echo "========================================================="
    echo "   Pink Auto Dev Environment Loaded (Nix Shell)          "
    echo "   - Flutter: \$(flutter --version | head -n 1)"
    echo "   - Java (JAVA_HOME): \$JAVA_HOME"
    echo "   - Android SDK: \$ANDROID_HOME"
    echo "========================================================="
  '';
}

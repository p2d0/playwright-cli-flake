{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  xorg,
  libxkbcommon,
  libgbm,
  atk,
  cairo,
  pango,
  gdk-pixbuf,
  glib,
  gtk3,
  alsa-lib,
  dbus,
  freetype,
  fontconfig,
  nss,
  nspr,
  cups,
  expat,
  libdrm,
  mesa,
  libxshmfence,
  version,
  srcHash,
  npmDepsHash,
}:
buildNpmPackage {
  pname = "playwright-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    rev = "v${version}";
    hash = srcHash;
  };

  inherit npmDepsHash;

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  postInstall = ''
    wrapProgram $out/bin/playwright-cli \
      --set PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS 1 \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          stdenv.cc.cc.lib
          xorg.libX11
          xorg.libXext
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXfixes
          xorg.libXi
          xorg.libXrender
          xorg.libxcb
          libxkbcommon
          libgbm
          atk
          cairo
          pango
          gdk-pixbuf
          glib
          gtk3
          alsa-lib
          dbus
          freetype
          fontconfig
          nss
          nspr
          cups
          expat
          libdrm
          mesa
          libxshmfence
          xorg.libXScrnSaver
        ]
      }
  '';

  meta = {
    description = "Playwright CLI";
    homepage = "https://playwright.dev/";
    license = lib.licenses.mit;
    mainProgram = "playwright-cli";
  };
}

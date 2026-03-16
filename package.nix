{ lib, buildNpmPackage, fetchFromGitHub, version, srcHash, npmDepsHash }:
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

  dontNpmBuild = true;

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  meta = {
    description = "Playwright CLI";
    homepage = "https://playwright.dev/";
    license = lib.licenses.mit;
    mainProgram = "playwright-cli";
  };
}

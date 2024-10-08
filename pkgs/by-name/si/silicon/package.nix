{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, expat
, freetype
, libxcb
, python3
, libiconv
, darwin
, fira-code
, fontconfig
, harfbuzz
}:

rustPlatform.buildRustPackage rec {
  pname = "silicon";
  # Remove `postPatch` hack below when updating.
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    hash = "sha256-fk1qaR7z9taOuNmjMCSdq7RybgV/3u7njU0Gehb98Lk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pathfinder_simd-0.5.2" = "sha256-b9RuxtTRKJ9Bnh0AWkoInRVrK/a3KV/2DCbXhN63yF0=";
    };
  };

  postPatch = ''
    # Fix build with Rust 1.80; remove when fixed upstream
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = [ expat freetype fira-code fontconfig harfbuzz ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libxcb ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
      libiconv
      AppKit
      CoreText
      Security
    ]);

  nativeBuildInputs = [ cmake pkg-config rustPlatform.bindgenHook ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ python3 ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs _0x4A6F ];
    mainProgram = "silicon";
  };
}

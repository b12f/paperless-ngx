{
  description = "Fundelio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
      flake = { };

      systems = [
        "x86_64-linux"
      ];

      perSystem = args@{ pkgs, ... }: {
        devShells.default =  let
          python = pkgs.python3.override {
            self = python;
            packageOverrides = final: prev: {
              django = prev.django_5;

              # tesseract5 may be overwritten in the paperless module and we need to propagate that to make the closure reduction effective
              ocrmypdf = prev.ocrmypdf.override { tesseract = pkgs.tesseract5; };
            };
          };
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            ghostscript_headless
            (pkgs.imagemagickBig.override { ghostscript = pkgs.ghostscript_headless; })
            jbig2enc
            optipng
            pngquant
            qpdf
            tesseract5
            unpaper
            poppler-utils

            (python.withPackages (python-pkgs: with python-pkgs; [
              bleach
              channels
              channels-redis
              concurrent-log-handler
              dateparser
              django_5
              django-allauth
              django-auditlog
              django-celery-results
              django-compression-middleware
              django-cors-headers
              django-extensions
              django-filter
              django-guardian
              django-multiselectfield
              django-soft-delete
              djangorestframework
              djangorestframework-guardian2
              drf-spectacular
              drf-spectacular-sidecar
              drf-writable-nested
              filelock
              flower
              gotenberg-client
              granian
              httpx-oauth
              imap-tools
              inotifyrecursive
              jinja2
              langdetect
              mysqlclient
              nltk
              ocrmypdf
              pathvalidate
              pdf2image
              psycopg
              python-dateutil
              python-dotenv
              python-gnupg
              python-ipware
              python-magic
              pyzbar
              rapidfuzz
              redis
              scikit-learn
              setproctitle
              tika-client
              tqdm
              watchdog
              whitenoise
              whoosh-reloaded
              zxing-cpp

              daphne
              factory-boy
              imagehash
              pytest
              pytest-cov-stub
              pytest-django
              pytest-env
              pytest-httpx
              pytest-mock
              pytest-rerunfailures
              pytest-xdist
              pytestCheckHook

              python-lsp-server
              python-lsp-jsonrpc
              python-lsp-black
              python-lsp-ruff
              pyls-isort
              pyls-flake8
              flake8
              isort
              black
            ]
            ++ django-allauth.optional-dependencies.mfa
            ++ django-allauth.optional-dependencies.socialaccount
            ++ redis.optional-dependencies.hiredis
            ))
          ];

          shellHook = ''
            echo 'hello'
          '';
        };
      };
    });
}

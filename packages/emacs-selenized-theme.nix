{
  lib,
  trivialBuild,
  fetchFromGitHub,
}:

trivialBuild {
  pname = "selenized-theme";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "jan-warchol";
    repo = "selenized";
    rev = "9a753d5c575c48e29eeb2be745d9571b4cec42b3";
    hash = "sha256-gS+LdNHGjai4EJXmJXORbWSY2vTxdL9w89HMR+sNldY=";
  };

  sourceRoot = "source/editors/emacs-WIP";

  postPatch = ''
    mv Selenized-black-theme.el selenized-black-theme.el
    mv Selenized-dark-theme.el selenized-dark-theme.el
  '';

  meta = {
    description = "Selenized themes for Emacs (selenized-black and selenized-dark)";
    homepage = "https://github.com/jan-warchol/selenized";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}

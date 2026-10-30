# GDB wrapped with the cmsis-svd Python package (not in nixpkgs),
# needed by the gdb-dashboard-svd module.
# To update the hash, run:
#   nix-prefetch-url https://files.pythonhosted.org/packages/source/c/cmsis-svd/cmsis_svd-0.6.tar.gz
# then convert: nix hash to-sri --type sha256 <output>
pkgs:
let
  cmsis-svd = pkgs.python3Packages.buildPythonPackage rec {
    pname = "cmsis_svd";
    version = "0.6";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-cMxYMG+AH5mlrWtJqLO06cyn0GsK7XcIH6zWmoQGRoY=";
    };
    build-system = [ pkgs.python3Packages.setuptools ];
    dependencies = [ pkgs.python3Packages.six pkgs.python3Packages.setuptools pkgs.python3Packages.lxml ];
    doCheck = false;
  };
  pythonWithCmsis = pkgs.python3.withPackages (_: [ cmsis-svd ]);
in
pkgs.symlinkJoin {
  name = "gdb-with-svd";
  paths = [ pkgs.gdb ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/gdb \
      --set PYTHONPATH "${pythonWithCmsis}/${pkgs.python3.sitePackages}"
  '';
}

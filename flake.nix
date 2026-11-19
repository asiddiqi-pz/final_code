{
  description = "Dev shell for Final_Project.ipynb (LFP / PCA / wavelet analysis)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        python = pkgs.python3.withPackages (ps: with ps; [
          # Jupyter / VS Code kernel support
          ipykernel
          ipywidgets
          jupyter

          # Libraries imported in the notebook
          numpy
          scipy
          matplotlib
          h5py
          pywavelets   # `import pywt`
          scikit-learn # `from sklearn...`
          requests
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            python
            pkgs.curl # the notebook uses `!curl ...` to download data
          ];

          shellHook = ''
            echo "Python: $(which python)"
            echo "Select this interpreter as the kernel in VS Code."
          '';
        };
      });
}

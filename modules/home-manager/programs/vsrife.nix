{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  hatchling,
  vapoursynth,
  numpy,
  tqdm,
  torch,
  tensorrt,
  tensorrtSupport ? false, # Doesn't work because torch-tensorrt isn't in nixpkgs
}: let
  modelFile = fetchurl {
    url = "https://github.com/HolyWu/vs-rife/releases/download/model/flownet_v4.25.pkl";
    hash = "sha256-ZhV5Dv1id3KRcgXbKR9RzTklKKFX7Lsuyu7Dv/jrbeI=";
    name = "flownet_v4.25.pkl";
  };
in
  buildPythonPackage rec {
    pname = "vs-rife";
    version = "5.7.0";

    pyproject = true;
    build-system = [hatchling];

    src = fetchFromGitHub {
      owner = "HolyWu";
      repo = "vs-rife";
      rev = "v${version}";
      hash = "sha256-uP18+IDEvTTFaYyhC4pMOTbR/yhiLUqn3/9TQw5BSDM=";
    };

    propagatedBuildInputs =
      [
        vapoursynth
        numpy
        torch
        tqdm
      ]
      ++ lib.optionals tensorrtSupport [tensorrt];

    preBuild = ''
      mkdir -p vsrife/models
      cp ${modelFile} vsrife/models/flownet_v4.25.pkl
    '';

    pythonImportsCheck = ["vsrife"];

    meta = with lib; {
      description = "VapourSynth Real-Time Intermediate Flow Estimation";
      homepage = "https://github.com/HolyWu/vs-rife";
      license = licenses.mit;
      maintainers = [];
    };
  }

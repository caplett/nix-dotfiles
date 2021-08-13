{
  autoPatchelfHook, pkgs
}:
pkgs.stdenv.mkDerivation rec {
  pname = "amd_gpu_tuxedo_patch";
  version = "5.9.20";

  rev = "104-1247438";
  src = pkgs.fetchurl {
    url = "https://deb.tuxedocomputers.com/ubuntu/pool/main/a/amdgpu-dkms/amdgpu-dkms-firmware_${version}.${rev}_all.deb";
    name = "amd_gpu-firmware";
    sha256 = "0z6xvxnyfm8x2yp31pamjxm5d5nqk2kyw69sdabc7x95yb59004p";
  };

  buildInputs = [
    pkgs.dpkg
  ];

    # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
  ];

  unpackPhase = "true";

  configurePhase = ''
  '';

  buildPhase = ''
    mkdir -p unpacked
    dpkg -x $src unpacked
  '';

  installPhase = ''
    mkdir -p $out
    cp -r unpacked/* $out/ 
  '';
}


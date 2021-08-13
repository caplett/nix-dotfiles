{
  autoPatchelfHook, pkgs
}:
pkgs.stdenv.mkDerivation rec {
  pname = "amd_gpu_tuxedo_patch";
  version = "5.9.20";

  rev = "104-1247438";
  src = pkgs.fetchurl {
    url = "https://deb.tuxedocomputers.com/ubuntu/pool/main/a/amdgpu-dkms/amdgpu-dkms_${version}.${rev}~tux2_all.deb";
    name = "amd_gpu-dkms";
    sha256 = "05i3kqimprwdmyzip2qzs4v16ybyp2mq1x0aqkvvrxg6dwwa2qjy";
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


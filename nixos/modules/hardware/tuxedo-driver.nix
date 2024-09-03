{ config, lib, ... }:
let
  cfg = config.hardware.tuxedo-driver;
  tuxedo-driver = config.boot.kernelPackages.tuxedo-driver;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "hardware"
        "tuxedo-keyboard"
      ]
      [
        "hardware"
        "tuxedo-driver"
      ]
    )
  ];

  options.hardware.tuxedo-driver = {
    enable = lib.mkEnableOption ''
      The tuxedo-driver driver enables access to the following on TUXEDO notebooks:
      - Driver for Fn-keys
      - SysFS control of brightness/color/mode for most TUXEDO keyboards
      - Hardware I/O driver for TUXEDO Control Center

      For more inforation it is best to check at the source code description: <https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers>
    '';
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tuxedo_keyboard" ];
    boot.extraModulePackages = [ tuxedo-driver ];
  };
}

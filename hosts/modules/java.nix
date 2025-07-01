{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jdk17
    maven
    gradle
    visualvm
  ];
}

final: prev: {
  hello = prev.hello.overrideAttrs (oldAttrs: rec {
    postInstall = ''
      echo "Custom hello package installed successfully!" > $out/share/hello-message.txt
    '';
  });
}

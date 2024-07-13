{ mainUser, setup }:

let
  hostnameConfig = import ./hostname.nix { inherit mainUser setup; };
in
{
  inherit (hostnameConfig) setups currentSetup hostName;
}

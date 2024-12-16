{...}: {
  imports = [./greetd ./tuigreet];

  # this option is an enum because we only
  # want one greeter enabled at a time.
  # enforcing this with asserts would get
  # very annoying as we add more greeters.
  options = {
    greeter = mkOption {
      type = types.enum [];
    };
  };
}

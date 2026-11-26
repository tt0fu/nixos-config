let
  rules = patterns: map (pattern: { inherit pattern; }) patterns;
in
{
  threads_sidebar.position = "right";
  dock = "right";
  enabled = true;

  favorite_models = [
    {
      provider = "deepseek";
      model = "deepseek-flash";
      enable_thinking = true;
      effort = "high";
    }
  ];
  default_model = {
    provider = "deepseek";
    model = "deepseek-flash";
    enable_thinking = true;
    effort = "high";
  };

  tool_permissions = {
    default = "confirm";
    tools = {
      terminal = {
        default = "confirm";

        always_allow = rules [
          # coreutils / system inspection
          "^ls(\\s|$)"
          "^eza(\\s|$)"
          "^cat(\\s|$)"
          "^bat(\\s|$)"
          "^head(\\s|$)"
          "^tail(\\s|$)"
          "^tac(\\s|$)"
          "^nl(\\s|$)"
          "^wc(\\s|$)"
          "^pwd\\s*$"
          "^echo(\\s|$)"
          "^printf(\\s|$)"
          "^true\\s*$"
          "^false\\s*$"
          "^test(\\s|$)"
          "^basename(\\s|$)"
          "^dirname(\\s|$)"
          "^realpath(\\s|$)"
          "^readlink(\\s|$)"
          "^stat(\\s|$)"
          "^file(\\s|$)"
          "^du(\\s|$)"
          "^df(\\s|$)"
          "^lsblk(\\s|$)"
          "^lscpu(\\s|$)"
          "^nproc\\s*$"
          "^free(\\s|$)"
          "^uptime\\s*$"
          "^date(\\s|$)"
          "^uname(\\s|$)"
          "^whoami\\s*$"
          "^id\\s*$"
          "^hostname\\s*$"
          "^groups\\s*$"
          "^env\\s*$"
          "^printenv(\\s|$)"
          "^which(\\s|$)"
          "^type(\\s|$)"
          "^command\\s+-v(\\s|$)"
          "^tldr(\\s|$)"
          "^notify-send(\\s|$)"
          "^clear\\s*$"
          "^history(\\s|$)"

          # process / socket inspection
          "^ps(\\s|$)"
          "^pgrep(\\s|$)"
          "^lsof(\\s|$)"
          "^ss(\\s|$)"
          "^netstat(\\s|$)"

          # searching / text processing (non-mutating)
          "^grep(\\s|$)"
          "^rg(\\s|$)"
          "^ag(\\s|$)"
          "^find(\\s|$)"
          "^fd(\\s|$)"
          "^tree(\\s|$)"
          "^diff(\\s|$)"
          "^cmp(\\s|$)"
          "^comm(\\s|$)"
          "^sort(\\s|$)"
          "^uniq(\\s|$)"
          "^cut(\\s|$)"
          "^tr(\\s|$)"
          "^fold(\\s|$)"
          "^column(\\s|$)"
          "^jq(\\s|$)"
          "^yq(\\s|$)"
          "^xxd(\\s|$)"
          "^hexdump(\\s|$)"
          "^od(\\s|$)"
          "^base64(\\s|$)"
          "^md5sum(\\s|$)"
          "^sha(1|256|512)sum(\\s|$)"

          # shell navigation builtins
          "^cd(\\s|$)"
          "^pushd(\\s|$)"
          "^popd(\\s|$)"

          # project-local file operations (the sandbox keeps writes
          # inside the project, so these cannot touch the rest of disk)
          "^mkdir(\\s|$)"
          "^touch(\\s|$)"
          "^ln(\\s|$)"
          "^cp(\\s|$)"
          "^mv(\\s|$)"
          "^chmod(\\s|$)"
          "^nixfmt(\\s|$)"
          "^shfmt(\\s|$)"
          "^deadnix(\\s|$)"
          "^statix(\\s|$)"

          # read-only git (mutating subcommands are confirmed below)
          "^git(\\s+(--no-pager|--no-optional-locks|-c\\s+\\S+|-C\\s+\\S+|--git-dir=\\S+|--work-tree=\\S+))*\\s+(status|log|diff|show|branch|remote|tag|describe|rev-parse|ls-files|ls-tree|blame|grep|shortlog|cat-file|reflog|rev-list|merge-base|show-ref|check-ignore|config\\s+--(get|list))(\\s|$)"
          "^git(\\s+--version|\\s+-v)\\s*$"

          # read-only nix
          "^nix\\s+(eval|search|show|hash|path-info|why-depends|fmt)(\\s|$)"
          "^nix\\s+flake\\s+(show|metadata)(\\s|$)"
          "^nix-instantiate\\s+--parse(\\s|$)"

          # service inspection
          "^systemctl(\\s+--user)?\\s+(status|show|cat|list-units|list-unit-files|is-active|is-enabled|is-failed)(\\s|$)"
          "^journalctl(\\s|$)"
        ];

        always_confirm = rules [
          "^(sudo|doas|pkexec|su)(\\s|$)"
          "^rm(\\s|$)"
          "^rmdir(\\s|$)"
          "^shred(\\s|$)"

          # mutating git
          "^git\\s+(push|commit|merge|rebase|cherry-pick|revert|am|apply|reset|clean|restore|checkout|switch|stash|submodule|init|clone|fetch|pull)(\\s|$)"
          "^git\\s+branch\\s+.*(-[dDmM]|--delete|--move|-[fF]|--force)"
          "^git\\s+remote\\s+(add|remove|rm|set-url|rename|prune|update)"
          "^git\\s+tag\\s+.*(-d|--delete|-[fF])"
          "^git\\s+reflog\\s+(delete|expire)"
          "^git\\s+config\\s+(--global|--system|-e|--edit|--add|--unset)"

          # system-changing / heavy nix operations
          "^nix\\s+(build|develop|run|shell|store|profile|registry|build-image|copy|sign|daemon)(\\s|$)"
          "^nix\\s+flake\\s+(check|update|lock)(\\s|$)"
          "^nixos-rebuild(\\s|$)"
          "^nh(\\s|$)"
          "^nix-collect-garbage(\\s|$)"
          "^nix-env(\\s|$)"

          # service / power / account management
          "^systemctl(\\s+--user)?\\s+(start|stop|restart|reload|reload-or-restart|try-restart|enable|disable|mask|unmask|daemon-reload|daemon-reexec|isolate|default|set-property|edit|link|preset)"
          "^(reboot|shutdown|poweroff|halt|suspend|hibernate)(\\s|$)"
          "^(kill|killall|pkill)(\\s|$)"
          "^(mount|umount|swapon|swapoff)(\\s|$)"
          "^(useradd|usermod|userdel|groupadd|groupmod|groupdel|passwd)(\\s|$)"
          "^(chown|chgrp)(\\s|$)"
          "^crontab(\\s|$)"
          "^at(\\s|$)"

          # network clients / containers / global installs
          "^(curl|wget)(\\s|$)"
          "^(ssh|scp|rsync|docker|podman)(\\s|$)"
          "^pip3?\\s+install(\\s|$)"
          "^npm\\s+install\\s+(-g|--global)"
          "^(gem|go|cargo)\\s+install(\\s|$)"

          # archive extraction can overwrite project files
          "^(tar|unzip|7z)(\\s|$)"
        ];

        always_deny = rules [
          # destructive disk / firmware operations
          "^mkfs(\\.\\w+)?(\\s|$)"
          "^(fdisk|parted|wipefs|mkswap)(\\s|$)"
          "^dd\\s+[^|]*\\bof=/dev/"
          ">\\s*/dev/(sd|nvme|hd|vd|mmcblk|dm-|disk)"
          "^(insmod|rmmod|modprobe)(\\s|$)"

          # firewall / kernel tunables
          "^(iptables|ip6tables|nft)(\\s|$)"
          "^sysctl\\s+-w"
          "^chattr(\\s|$)"

          # recursive permission changes on system paths
          "^chmod\\s+-R\\s+\\S*\\s+/(etc|usr|boot|nix|bin|sbin|lib|lib64|var|root|opt)(/|\\s|$)"
          "^chown\\s+-R\\s+\\S+\\s+/(etc|usr|boot|nix|bin|sbin|lib|lib64|var|root|opt)(/|\\s|$)"
          "^chmod\\s+-R\\s+\\S+\\s+(/(home|Users)(/|\\s|$)|/(\\s|\\*|$)|~(\\s|/|\\*|$))"
          "^chown\\s+-R\\s+\\S+\\s+(/(home|Users)(/|\\s|$)|/(\\s|\\*|$)|~(\\s|/|\\*|$))"
          ">>?\\s*/(etc|usr|boot|nix|bin|sbin|lib|lib64|root)(/|\\s|$)"

          # download-and-execute
          "\\b(curl|wget)\\b[^|]*\\|\\s*(sudo\\s+)?(ba|z|da|k|fi)?sh(\\s|$)"
          "\\b(curl|wget)\\b[^|]*\\|\\s*(python[0-9.]*|perl|ruby|node)(\\s|$)"
          "^(eval|source|\\.)\\s+\\(?\\s*(curl|wget)\\b"

          # raw network clients bypass the host-scoped sandbox proxy
          "^(nc|ncat|netcat|socat|telnet|ftp|sftp|tftp)(\\s|$)"

          # fork bomb
          ":\\(\\)\\s*\\{\\s*:\\s*\\|\\s*:\\s*&\\s*\\}\\s*;\\s*:"

          "^history\\s+-c"
        ];
      };

      fetch = {
        default = "confirm";
        always_allow = rules [
          "^https?://([a-z0-9-]+\\.)*zed\\.dev(:|/|$)"
          "^https?://docs\\.rs(:|/|$)"
          "^https?://doc\\.rust-lang\\.org(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*github\\.com(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*githubusercontent\\.com(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*gitlab\\.com(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*nixos\\.org(:|/|$)"
          "^https?://nix-community\\.github\\.io(:|/|$)"
          "^https?://noogle\\.dev(:|/|$)"
          "^https?://nix\\.dev(:|/|$)"
          "^https?://discourse\\.nixos\\.org(:|/|$)"
          "^https?://developer\\.mozilla\\.org(:|/|$)"
          "^https?://(www\\.)?man7\\.org(:|/|$)"
          "^https?://(www\\.)?archlinux\\.org(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*stackoverflow\\.com(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*crates\\.io(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*pypi\\.org(:|/|$)"
          "^https?://([a-z0-9-]+\\.)*npmjs\\.com(:|/|$)"
          "^https?://pkg\\.go\\.dev(:|/|$)"
          "^https?://(www\\.)?gnu\\.org(:|/|$)"
        ];
        always_deny = rules [
          # loopback, link-local and RFC1918 / ULA targets
          "^https?://(localhost|127\\.|0\\.0\\.0\\.0|\\[::1\\])(:|/|$)"
          "^https?://10\\.\\d+\\.\\d+\\.\\d+"
          "^https?://192\\.168\\.\\d+\\.\\d+"
          "^https?://172\\.(1[6-9]|2\\d|3[01])\\.\\d+\\.\\d+"
          "^https?://169\\.254\\.\\d+\\.\\d+"
          "^https?://\\[?(fc|fd)[0-9a-f]{2}:"

          # credentials embedded in URLs
          "^https?://[^/\\s]*@"

          # internal-only TLDs
          "\\.(internal|local|lan|corp)(:|/|$)"

          # non-HTTP schemes
          "^file:"
        ];
      };

      search_web.default = "allow";

      edit_file = {
        default = "allow";
        always_confirm = rules [
          "(^|/)\\.env(\\.|/|$)"
          "(^|/)secrets?(/|$)"
          "(^|/)\\.ssh(/|$)"
          "(^|/)\\.gnupg(/|$)"
          "(^|/)id_(rsa|ed25519|ecdsa|dsa)(\\.pub)?$"
          "\\.(pem|key|p12|pfx|jks|keystore|kdbx)$"
          "(^|/)\\.github/workflows/"
          "(^|/)hardware-configuration\\.nix$"
        ];
        always_deny = rules [
          "(^|/)\\.git(/|$)"
        ];
      };
      write_file = {
        default = "allow";
        always_confirm = rules [
          "(^|/)\\.env(\\.|/|$)"
          "(^|/)secrets?(/|$)"
          "(^|/)\\.ssh(/|$)"
          "(^|/)\\.gnupg(/|$)"
          "(^|/)id_(rsa|ed25519|ecdsa|dsa)(\\.pub)?$"
          "\\.(pem|key|p12|pfx|jks|keystore|kdbx)$"
          "(^|/)\\.github/workflows/"
          "(^|/)hardware-configuration\\.nix$"
        ];
        always_deny = rules [
          "(^|/)\\.git(/|$)"
        ];
      };
      delete_path = {
        default = "confirm";
        always_deny = rules [
          "(^|/)\\.git(/|$)"
          "(^|/)\\.ssh(/|$)"
          "(^|/)\\.gnupg(/|$)"
          "^/(etc|usr|boot|nix|bin|sbin|lib|lib64|proc|sys|dev|root|var|opt)(/|$)"
          "^~(/|$)"
        ];
        always_confirm = rules [
          "(^|/)nixos-config/?$"
        ];
      };
      move_path = {
        default = "allow";
        always_confirm = rules [
          "(^|/)\\.env(\\.|/|$)"
          "(^|/)secrets?(/|$)"
          "(^|/)\\.git(/|$)"
        ];
      };
      copy_path = {
        default = "allow";
        always_confirm = rules [
          "(^|/)\\.env(\\.|/|$)"
          "(^|/)secrets?(/|$)"
          "(^|/)\\.ssh(/|$)"
          "\\.(pem|key|p12|pfx)$"
        ];
      };
      create_directory = {
        default = "allow";
        always_deny = rules [
          "^/(etc|usr|boot|nix|bin|sbin|lib|lib64|proc|sys|dev|root)(/|$)"
        ];
      };

      skill.default = "allow";
    };
  };

  sandbox_permissions = {
    network_hosts = [
      "github.com"
      "*.github.com"
      "*.githubusercontent.com"
      "*.gitlab.com"
      "*.nixos.org"
      "*.nix-community.org"
      "*.crates.io"
      "static.crates.io"
      "index.crates.io"
      "*.npmjs.org"
      "registry.npmjs.org"
      "*.pypi.org"
      "files.pythonhosted.org"
      "*.zed.dev"
      "noogle.dev"
    ];
  };
}

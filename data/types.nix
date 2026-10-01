# Option declarations for cv.nix. Evaluated by default.nix via lib.evalModules,
# so unknown fields, missing required fields, and wrong types are eval errors.
{ lib, ... }:
let
  inherit (lib) mkOption types;

  str = mkOption { type = types.str; };
  optional =
    type:
    mkOption {
      type = types.nullOr type;
      default = null;
    };

  date = types.strMatching "[0-9]{4}(-[0-9]{2})?";
  url = types.strMatching "https?://.+";
  urlOrEmpty = types.strMatching "(https?://.+)?";

  # Every collection entry gets a read-only id derived from its attribute name.
  idOption =
    prefix: name:
    mkOption {
      type = types.str;
      default = "${prefix}:${name}";
      readOnly = true;
    };

  # A reference is written as the entry itself (config.education.uiuc) and
  # stored as its id; the prefix restricts which collections it may point to.
  ref =
    prefixes:
    types.coercedTo (types.addCheck types.attrs (x: x ? id)) (x: x.id) (
      types.strMatching "(${lib.concatStringsSep "|" prefixes}):.+"
    );

  refs =
    prefixes:
    mkOption {
      type = types.listOf (ref prefixes);
      default = [ ];
    };

  allPrefixes = [
    "edu"
    "research"
    "work"
    "pub"
    "activity"
    "project"
    "skill"
  ];

  # Entry-level relationships. Declare each one once, on one side and at one
  # level; prefer a highlight's contains over the entry's.
  relations = withinPrefixes: {
    within = refs withinPrefixes;
    contains = refs allPrefixes;
  };

  entry =
    prefix: options:
    types.submodule (
      { name, ... }: {
        options = {
          id = idOption prefix name;
        }
        // options;
      }
    );

  shortLong = types.submodule {
    options = {
      long = str;
      short = str;
    };
  };

  location = types.submodule {
    options = {
      city = str;
      state = str;
      country = str;
    };
  };

  link = types.submodule {
    options = {
      label = optional types.str;
      url = mkOption { type = url; };
    };
  };

  highlight = types.submodule {
    options = {
      text = str;
      details = optional types.str;
      links = mkOption {
        type = types.listOf link;
        default = [ ];
      };
      contains = refs [
        "skill"
        "pub"
        "project"
      ];
    };
  };

  # Skills may be written as a bare display name.
  skill = types.coercedTo types.str (name: { inherit name; }) (
    entry "skill" {
      name = str;
    }
  );

  dated = {
    startDate = mkOption { type = date; };
    endDate = optional date;
  };

  experience = {
    role = str;
    highlights = mkOption {
      type = types.listOf highlight;
      default = [ ];
    };
  }
  // dated;
in
{
  options = {
    person = mkOption {
      type = types.submodule {
        options = {
          name = str;
          email = str;
          links = mkOption {
            type = types.listOf link;
            default = [ ];
          };
          summary = mkOption {
            type = types.submodule {
              options = {
                long = optional types.str;
                short = str;
              };
            };
          };
        };
      };
    };

    # Grouped by category: skills.<category>.<id>.
    skills = mkOption { type = types.attrsOf (types.attrsOf skill); };

    education = mkOption {
      type = types.attrsOf (
        entry "edu" (
          {
            name = mkOption { type = shortLong; };
            link = optional urlOrEmpty;
            location = mkOption { type = location; };
            degrees = mkOption {
              type = types.nonEmptyListOf (
                types.submodule {
                  options = {
                    degree = str;
                    field = str;
                    concentration = optional shortLong;
                  };
                }
              );
            };
            gpa = optional types.number;
            honors = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
          }
          // dated
          // relations allPrefixes
        )
      );
    };

    publications = mkOption {
      type = types.attrsOf (
        entry "pub" {
          title = str;
          authors = mkOption { type = types.nonEmptyListOf types.str; };
          venue = str;
          date = mkOption { type = date; };
          awards = mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
        }
        // relations allPrefixes
      );
    };

    research = mkOption {
      type = types.attrsOf (
        entry "research" (
          {
            lab = str;
            pi = mkOption {
              type = types.submodule {
                options = {
                  name = str;
                  link = optional urlOrEmpty;
                };
              };
            };
          }
          // experience
          // relations [ "edu" ]
        )
      );
    };

    work = mkOption {
      type = types.attrsOf (
        entry "work" (
          {
            organization = mkOption {
              type = types.submodule {
                options = {
                  name = str;
                  link = optional url;
                };
              };
            };
            location = mkOption { type = location; };
          }
          // experience
          // relations [ "edu" ]
        )
      );
    };

    activities = mkOption {
      type = types.attrsOf (
        entry "activity" (
          {
            organization = str;
          }
          // dated
          // relations [ "edu" ]
        )
      );
    };

    projects = mkOption {
      type = types.attrsOf (
        entry "project" (
          {
            title = str;
            description = optional types.str;
            links = mkOption {
              type = types.listOf link;
              default = [ ];
            };
          }
          // relations allPrefixes
        )
      );
    };
  };
}

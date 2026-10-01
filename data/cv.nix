{ config, ... }:
{
  person = {
    name = "Kevin Fisher";
    email = "kf23@illinois.edu";
    links = [
      {
        label = "GitHub";
        url = "https://github.com/kfish610";
      }
      {
        label = "LinkedIn";
        url = "https://www.linkedin.com/in/kfish610";
      }
    ];
    summary = {
      long = "";
      short = "Seeking research opportunities in order to gain further research experience, to contribute my interest in and knowledge of computer science and mathematics, and to help build tools that assist humans with proofs.";
    };
  };

  skills = {
    programming = {
      python = "Python";
      csharp = "C#";
      cpp = "C++";
      r = "R";
      java = "Java";
      javascript = "JavaScript";
      scala = "Scala";
      haskell = "Haskell";
    };
    provers = {
      lean = "Lean";
      rocq = "Rocq";
      agda = "Agda";
    };
    general = {
      teaching = "Teaching, Tutoring, and Grading";
      presenting = "Public Speaking and Presenting";
    };
  };

  education = {
    uiuc = {
      name = {
        long = "University of Illinois Urbana-Champaign";
        short = "UIUC";
      };
      link = "";
      location = {
        city = "Urbana-Champaign";
        state = "Illinois";
        country = "USA";
      };
      startDate = "2025-08";
      degrees = [
        {
          degree = "Ph.D.";
          field = "Computer Science";
          concentration = {
            long = "Programming Languages, Formal Methods, and Software Engineering";
            short = "PL/FM/SE";
          };
        }
      ];
    };
    ucsd = {
      name = {
        long = "University of California San Diego";
        short = "UC San Diego";
      };
      link = "";
      location = {
        city = "San Diego";
        state = "California";
        country = "USA";
      };
      startDate = "2021-09";
      endDate = "2025-06";
      degrees = [
        {
          degree = "B.S.";
          field = "Cognitive Science";
          concentration = {
            long = "Specialization in Machine Learning and Neural Computation";
            short = "w/ spec. ML";
          };
        }
        {
          degree = "B.S.";
          field = "Mathematics";
        }
      ];
      gpa = 3.93;
      honors = [ "Provost Honors" ];
      contains = [
        config.skills.programming.python
        config.skills.programming.r
      ];
    };
  };

  publications = {
    rango = {
      title = "Rango: Adaptive Retrieval-Augmented Proving for Automated Software Verification";
      authors = [
        "Robert Thompson"
        "Nuno Saavedra"
        "Pedro Carrott"
        config.person.name
        "Alex Sanchez-Stern"
        "Yuriy Brun"
        "João F. Ferreira"
        "Sorin Lerner"
        "Emily First"
      ];
      venue = "ICSE";
      date = "2025";
      awards = [ "Distinguished Paper Award" ];
    };
  };

  research = {
    uiuc = {
      lab = "ITP Lab";
      pi = {
        name = "Talia Ringer";
        link = "";
      };
      startDate = "2025-08";
      role = "PhD Student";
      within = [ config.education.uiuc ];
      highlights = [
        {
          text = "Researching methods to improve LLM proof generation";
          contains = [
            config.skills.provers.lean
            config.skills.provers.rocq
            config.skills.provers.agda
            config.skills.programming.python
          ];
        }
      ];
    };
    ucsd = {
      lab = "Sorin Lerner's Lab";
      pi = {
        name = "Sorin Lerner";
        link = "";
      };
      startDate = "2024-02";
      endDate = "2025-06";
      role = "Research Assistant";
      within = [ config.education.ucsd ];
      highlights = [
        {
          text = "Author on a distinguished paper at ICSE 2025";
          contains = [
            config.publications.rango
            config.skills.provers.rocq
            config.skills.programming.python
          ];
        }
      ];
    };
  };

  work = {
    galois = {
      organization = {
        name = "Galois";
        link = "https://galois.com";
      };
      location = {
        city = "Portland";
        state = "Oregon";
        country = "USA";
      };
      startDate = "2025-06";
      endDate = "2025-08";
      role = "Research Intern";
      highlights = [
        {
          text = "Investigated agent capabilities of small models";
          links = [
            {
              label = "Article";
              url = "https://www.galois.com/articles/privacy-vs-power-can-llms-succeed-in-security-critical-environments";
            }
          ];
        }
        {
          text = "Created a Scala DSL for modeling finite automata";
          contains = [ config.skills.programming.scala ];
        }
      ];
    };
    its = {
      organization = {
        name = "ITS Service Desk";
        link = "https://blink.ucsd.edu/technology/help-desk/service-desk/index.html";
      };
      location = config.education.ucsd.location;
      startDate = "2022-07";
      endDate = "2025-06";
      role = "Lead Technician";
      within = [ config.education.ucsd ];
      contains = [
        config.skills.programming.javascript
      ];
      highlights = [
        {
          text = "Advised and mentored new technicians";
        }
      ];
    };
    reader = {
      organization = {
        name = config.education.ucsd.name.short;
        link = "https://math.ucsd.edu";
      };
      location = config.education.ucsd.location;
      startDate = "2024-09";
      endDate = "2024-12";
      role = "Mathematics Reader";
      within = [ config.education.ucsd ];
      highlights = [
        {
          text = "Graded and provided comprehensive feedback on problem sets for 120+ graph theory students";
          contains = [ config.skills.general.teaching ];
        }
      ];
    };
  };

  activities = {
    film-score = {
      organization = "Film Score Orchestra";
      startDate = "2025-08";
      within = [ config.education.uiuc ];
    };
    intermission = {
      organization = "The Intermission Orchestra";
      startDate = "2022-09";
      endDate = "2025-06";
      within = [ config.education.ucsd ];
    };
  };

  projects = { };
}

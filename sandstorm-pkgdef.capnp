@0x8b8d9e21789be80e;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "1gda5n8p8zsc0r9pcana2yjgtvsq169068k4ve8mk68z4x9fvzuh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "EtherDraw"),

    appVersion = 3,  # Increment this for every release.

    appMarketingVersion = (defaultText = "0.2"),

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New EtherDraw"),
        nounPhrase = (defaultText = "drawing"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
       icons = (
         appGrid = (svg = embed "app-graphics/etherdraw-128.svg"),
         grain = (svg = embed "app-graphics/etherdraw-24.svg"),
         market = (svg = embed "app-graphics/etherdraw-150.svg"),
       ),

       website = "http://draw.etherpad.org/",
       codeUrl = "https://github.com/ocdtrekkie/draw",
       license = (openSource = apache2),
       categories = [graphics],

       author = (
         contactEmail = "inbox@jacobweisz.com",
         pgpSignature = embed "pgp-signature",
         upstreamAuthor = "Etherpad Foundation",
       ),
       pgpKeyring = embed "pgp-keyring",

       description = (defaultText = embed "description.md"),
       shortDescription = (defaultText = "Whiteboard"),

       screenshots = [
         (width = 1920, height = 1080, png = embed "sandstorm-screenshot.png")
       ],

       changeLog = (defaultText = embed "CHANGELOG.md"),
    ),
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = []
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "9002", "--", "bin/run.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);

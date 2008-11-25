The subversion module provides a ``subversion`` class and a
``working-copy`` definition. It has only been tested on Debian Etch.

``class subversion``:
  Installs the ``subversion`` and ``subversion-tools`` packages, as well as ``xmlstarlet``, which is required for the ``working-copy`` definition.

``define subversion::working-copy``:
  - ``$name``: The name of the subversion project. This will be used to
  construct the URL used to check out the project.
  - ``$repo_base``: The base of the URL of the subversion
  repository. For example, if the subversion repository was located in
  ``/repository`` on the host ``subversion.example.com`` you would set
  ``$repo_base`` to ``subversion.example.com/repository``. This will
  be  used to construct the URL used to check out the project.
  - ``$path``: The desired location of the working copy.
  - ``$branch``: (default: "trunk") The name of the branch you would
    like to check out. This will be used to construct the URL used to
    check out the project.
  - ``$svn_ssh``: (default: "false") If set, this will be used as the
    value of the SVN_SSH environment variable while running Subversion
   commands.
  - ``$owner``: (default: "root") The owner of the working copy.
  - ``$group``: (default: "root") The group of the working copy.

  Checks out a copy of the named subversion project into the specified
  directory. Keeps the working copy in sync with the repository. The
  URL that is used to check out the working copy is constructed from
  the provided parameters like so:
  ``svn+ssh://$repo_base/$name/trunk`` or, if a branch is specified,
  ``svn+ssh://$repo_base/$name/branches/$branch``.

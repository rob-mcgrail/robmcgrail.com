# Where the public folders live
PUBLIC_ROOT = 'public'

# The public folders - best not to change these as the template helpers assume they exist as below
PUBLIC_FOLDERS = ['/audio', '/files', '/images', '/javascript', '/stylesheets', '/video', '/tmp', '/robots.txt']

# The name of the site - used in title template helper
SETTINGS[:sitename] = 'robmcgrail.com'

# url of the site
SETTINGS[:hostname] = '0.0.0.0'

# The base template - this should lay out everything up to and including <body>, then yield
SETTINGS[:app_layout] = 'layouts/application'

# GA tracking code, used in the ga_tracking template helper
SETTINGS[:ga_caode] = 'UA-10148230-1'

# While true, throws proper errors. When nil, errors run the Error#bug controller
SETTINGS[:development_mode] = true

# Chose coderay stylesheet (public/stylesheets/code/) - rack, idlecopy,
SETTINGS[:coderay_css] = 'rack'

# Maximum bytes for the template chache (caches raw haml in memory to save on disk reads)
SETTINGS[:template_cache_max] = 1_000_000

# Maximum bytes for the hard chache (caches compiled html in memory to save on haml/db cycles)
SETTINGS[:hard_cache_max] = 1_000_000

# Location of views. Slash on both sides, in app root.
SETTINGS[:view_folder] = '/views/'


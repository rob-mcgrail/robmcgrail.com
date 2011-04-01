# Where the public folders live
PUBLIC_ROOT = 'public'

# The public folders - best not to change these as the template helpers assume they exist as below
PUBLIC_FOLDERS = ['/audio', '/files', '/images', '/javascript', '/stylesheets', '/video', '/tmp', '/robots.txt']

# The name of the site - used in title template helper
SITENAME = 'robmcgrail.com'

# The base template - this should lay out everything up to and including <body>, then yield
APP_TEMPLATE = 'layouts/application'

# GA tracking code, used in the ga_tracking template helper
GA_CODE = 'UA-10148230-1'

# While true, throws proper errors. When false, errors run the Error#bug controller
DEVELOPMENT_MODE = true

# Chose coderay stylesheet (public/stylesheets/code/) - rack, idlecopy,
CODERAY_CSS = 'rack'

# Maximum bytes for the template chache (caches raw haml in memory to save on disk reads)
TEMPLATE_CACHE_MAX = 1_000_000

# Path for logfiles
LOG_FILE = 'public/rack.log'


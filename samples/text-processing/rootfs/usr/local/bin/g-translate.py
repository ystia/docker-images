#!/usr/bin/env python3

import sys
from googletrans import Translator

f=open(sys.argv[1])

translator = Translator()
t=translator.translate(f.read(), dest='en')

print(t.text)

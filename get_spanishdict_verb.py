# coding=utf-8
# Gets a verb conjugation information from spanishdict.com
# Reference: http://docs.python-guide.org/en/latest/scenarios/scrape/

import io, json, sys
import requests
from lxml import html
from pprint import pprint

class Verb:
    VERB_URL = "http://www.spanishdict.com/conjugate/%s"
    VERB_MOODS = {"indicative": {"index": 0, "tenses": ["Present", "Preterite", "Imperfect", "Conditional", "Future"]}, \
                  "Subjunctive": {"index": 1, "tenses": ["Present", "Imperfect", "Imperfect 2", "Future"]} , \
                  "Imperative": {"index": 2, "tenses": ["imperative"]}, \
                  "Perfect": {"index": 3, "tenses": ["Present", "Preterite", "Past", "Conditional", "Future"]}, \
                  "Perfect Subjunctive": {"index": 4, "tenses": ["Present", "Past", "Future"] }\
                 }
    PRONOUNS = {"yo": 1, \
                "tú": 2, \
                "él/ella/Ud.": 3, \
                "nosotros": 4, \
                "vosotros": 5, \
                "ellos/ellas/Uds.": 6 \
    }
    def __init__(self, verb):
        self.verb = verb

    def getConjugation(self):
        ans = {}
        page = requests.get(Verb.VERB_URL % self.verb)
        tree = html.fromstring(page.text)
        for mood, moodData in Verb.VERB_MOODS.items():
            moodDict = {}
            for tenseIndex in range(len(moodData["tenses"])):
                tense = moodData["tenses"][tenseIndex]
                moodDict[tense] = {}
                for pronoun, pronounIndex in Verb.PRONOUNS.items():
                    moodDict[tense][pronoun] = self.__getSpecificConjugation(tree, moodData["index"], pronounIndex, tenseIndex)
            ans[mood] = moodDict
        return ans

    def __getSpecificConjugation(self, tree, moodIndex, pronounIndex, tenseIndex):
        return tree.body.xpath('//table[@class="vtable"]')[moodIndex][pronounIndex][tenseIndex + 1].text


if __name__ == "__main__":
    verb = sys.argv[1]
    conjugation = Verb(verb).getConjugation()
    with io.open("result.json", "w") as file:
        json_string = json.dumps(conjugation)
        file.write(unicode(json_string))

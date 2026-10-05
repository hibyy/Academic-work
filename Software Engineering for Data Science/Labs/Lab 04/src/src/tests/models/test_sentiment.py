from textblob import TextBlob
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))
from src.models.sentiment import extract_sentiment
import pytest

testdata =["Borussia Dortmunds loss was heartbreaking as they failed to gain momentums from their  two goals advance. Very disappointing results for our Algerian player Bensebaini.",
           "Barcelona played brilliantly last Wednesday. Rafinias hat-trick was pure magic. Visca Barça!"]
@pytest.mark.parametrize('sample', testdata)
def test_extract_sentiment(sample):

    neg_sentiment = extract_sentiment(sample)

    assert neg_sentiment <= 0
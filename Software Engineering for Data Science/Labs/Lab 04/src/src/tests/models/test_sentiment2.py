import pytest
import pandas as pd
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../..")))
from src.models.sentiment import extract_sentiment

# Load sentiment data from CSV
data = pd.read_csv('src/tests/data/soccer_sentiment_analysis.csv')  # Update this path
testdata = data['Text'].tolist()  # Assuming your CSV has a column named 'text'

@pytest.mark.parametrize('sample', testdata)
# def test_extract_sentiment_from_csv(sample):
#     sentiment = extract_sentiment(sample)
#     # Check for neutrality; you can adjust the logic depending on the sentiment you expect
#     assert sentiment <= 0

def test_specific_positive_sentiment(sample):
    pos_sentiment = extract_sentiment(sample)
    assert pos_sentiment > 0    

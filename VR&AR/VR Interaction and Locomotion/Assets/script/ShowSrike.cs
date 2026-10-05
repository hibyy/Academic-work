using UnityEngine;
using TMPro;

public class ScoreUI : MonoBehaviour
{
    public TextMeshProUGUI text;

    public void ShowStrike()
    {
        text.text = "STRIKE !";
    }

    public void ShowLose()
    {
        text.text = "PERDU !";
    }
}
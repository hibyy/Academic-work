using UnityEngine;

public class Gutter : MonoBehaviour
{
    private ScoreUI scoreUI;

    void Start()
    {
        // 🔥 récupérer le Canvas automatiquement
        scoreUI = FindObjectOfType<ScoreUI>();
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.name == "BowlingBall")
        {
            Debug.Log("PERDU !");

            // 🔥 afficher PERDU dans UI
            if (scoreUI != null)
                scoreUI.ShowLose();
        }
    }
}
using UnityEngine;

public class PinCollision : MonoBehaviour
{
    private AudioSource audioSource;
    private ScoreUI scoreUI;

    private static bool hasStriked = false; // 🔥 partagé entre toutes les quilles

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        scoreUI = FindObjectOfType<ScoreUI>();
    }

    void OnCollisionEnter(Collision collision)
    {
        // Vérifie que c'est la boule
        if (collision.gameObject.name != "BowlingBall") return;

        // Impact suffisamment fort
        if (collision.relativeVelocity.magnitude > 1f)
        {
            audioSource.Play();

            // 🔥 afficher STRIKE une seule fois
            if (!hasStriked && scoreUI != null)
            {
                scoreUI.ShowStrike();
                hasStriked = true;
            }
        }
    }
}
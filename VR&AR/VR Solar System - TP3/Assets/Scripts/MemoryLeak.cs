using UnityEngine;

public class MemoryLeak: MonoBehaviour
{
    public float lifeTime = 5f; // Durée avant destruction automatique

    void Start()
    {
        // Détruire l'objet après 5 secondes
        Destroy(gameObject, lifeTime);
    }

    void Update()
    {
        // Détruire si la météorite tombe trop bas
        if (transform.position.y < -10f)
        {
            Destroy(gameObject);
        }
    }
}

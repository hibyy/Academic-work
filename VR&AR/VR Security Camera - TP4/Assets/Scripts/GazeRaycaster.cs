using UnityEngine;

public class GazeRaycaster : MonoBehaviour
{
    public float viewDistance = 20f;   // Distance du regard

    private GazeButton currentButton;  // Bouton actuellement regardé

    void Update()
    {
        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;

        Debug.DrawRay(ray.origin, ray.direction * viewDistance, Color.blue);

        if (Physics.Raycast(ray, out hit, viewDistance))
        {
            // Vérifier si l'objet touché a un GazeButton
            GazeButton button = hit.collider.GetComponent<GazeButton>();

            if (button != null)
            {
                // Si on regarde un nouveau bouton
                if (currentButton != button)
                {
                    // On arrête l'ancien
                    if (currentButton != null)
                    {
                        currentButton.OnLookEnd();
                    }

                    // On démarre le nouveau
                    currentButton = button;
                    currentButton.OnLookStart();
                }
            }
            else
            {
                // On regarde autre chose → arrêter
                ClearCurrentButton();
            }
        }
        else
        {
            // Rien touché → arrêter
            ClearCurrentButton();
        }
    }

    void ClearCurrentButton()
    {
        if (currentButton != null)
        {
            currentButton.OnLookEnd();
            currentButton = null;
        }
    }
}
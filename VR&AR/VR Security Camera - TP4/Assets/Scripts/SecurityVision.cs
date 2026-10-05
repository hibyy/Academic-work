using UnityEngine;

public class SecurityVision : MonoBehaviour
{
    public float viewDistance = 20f;
    public LayerMask obstaclesLayer;

    public Color alertColor = Color.red;
    public Color normalColor = Color.green;

    private Renderer camRenderer;

    void Start()
    {
        camRenderer = GetComponentInChildren<Renderer>();
    }

    void Update()
    {
        Ray ray = new Ray(transform.position, transform.forward);
        RaycastHit hitInfo;

        Debug.DrawRay(ray.origin, ray.direction * viewDistance, Color.yellow);

        if (Physics.Raycast(ray, out hitInfo, viewDistance))
        {
            Debug.Log("Je vois : " + hitInfo.collider.name);

            if (hitInfo.collider.CompareTag("Player"))
            {
                ChangeColor(alertColor);
            }
            else
            {
                ChangeColor(normalColor);
            }
        }
        else
        {
            ChangeColor(normalColor);
        }
    }

    void ChangeColor(Color c)
    {
        if (camRenderer != null)
            camRenderer.material.color = c;
    }
}
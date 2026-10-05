using UnityEngine;
using UnityEngine.Events;

public class FeedbackButton : MonoBehaviour
{
    public Color normalColor = Color.red;
    public Color hoverColor = Color.yellow;
    public Color pressColor = Color.green;

    public UnityEvent onPressed;

    private Renderer rend;
    private Vector3 originalPos;

    void Start()
    {
        rend = GetComponent<Renderer>();
        originalPos = transform.localPosition;
        rend.material.color = normalColor;
    }

    void OnMouseEnter()
    {
        rend.material.color = hoverColor;
    }

    void OnMouseExit()
    {
        rend.material.color = normalColor;
        transform.localPosition = originalPos;
    }

    void OnMouseDown()
    {
        rend.material.color = pressColor;
        transform.localPosition = originalPos + Vector3.back * 0.1f;
        onPressed.Invoke();
    }

    void OnMouseUp()
    {
        rend.material.color = hoverColor;
    }
}
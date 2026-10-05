using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class SimpleRayVisual : MonoBehaviour
{
    public float length = 10f;

    private LineRenderer lr;

    void Start()
    {
        lr = GetComponent<LineRenderer>();
    }

    void Update()
    {
        Vector3 start = transform.position;
        Vector3 end = transform.position + transform.forward * length;

        lr.SetPosition(0, start);
        lr.SetPosition(1, end);
    }
}
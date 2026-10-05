using UnityEngine;

public class Orbit : MonoBehaviour
{
    public Transform pivot;
    public Vector3 axis = Vector3.up;
    public float speed = 20f;

    void Update()
    {
        if (pivot != null)
        {
            transform.RotateAround(pivot.position, axis, speed * Time.deltaTime);
        }
        else
        {
            transform.Rotate(axis, speed * Time.deltaTime);
        }
    }
}
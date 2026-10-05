using UnityEngine;

public class SnapTurn : MonoBehaviour
{
    public float snapAngle = 45f;
    private bool canTurn = true;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && canTurn)
        {
            transform.Rotate(0, snapAngle, 0);
        }
        else if (Input.GetKeyDown(KeyCode.Q) && canTurn)
        {
            transform.Rotate(0, -snapAngle, 0);
        }
    }
}
using UnityEngine;

public class BallLauncher : MonoBehaviour
{
    public float force = 1000f;

    Rigidbody rb;

    bool launchBall = false;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // 1️⃣ INPUT (Update)
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            launchBall = true;
        }

        if (Input.GetKeyDown(KeyCode.R))
        {
            transform.position = new Vector3(0, 0.5f, 0);
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
        }
    }

    // 2️⃣ PHYSICS (FixedUpdate)
    void FixedUpdate()
    {
        if (launchBall)
        {
            rb.AddForce(Vector3.forward * force);
            launchBall = true; // نديروها مرة وحدة
        }
    }
}
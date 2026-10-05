using UnityEngine;

public class GazeButton : MonoBehaviour
{
    public float activationTime = 2.0f;

    private float timer = 0f;
    private bool isBeingLookedAt = false;

    public void OnLookStart()
    {
        isBeingLookedAt = true;
    }

    public void OnLookEnd()
    {
        isBeingLookedAt = false;
        timer = 0f;
        GetComponent<Renderer>().material.color = Color.white;
    }

    void Update()
    {
        if (isBeingLookedAt)
        {
            timer += Time.deltaTime;

            float ratio = timer / activationTime;

            GetComponent<Renderer>().material.color =
                Color.Lerp(Color.white, Color.green, ratio);

            if (timer >= activationTime)
            {
                Debug.Log("BOUTON ACTIVE !");
                timer = 0f;
            }
        }
    }
}
using UnityEngine;

public class Teleporter : MonoBehaviour
{
    public float range = 50f;
    public GameObject indicatorPrefab;

    private GameObject indicator;
    private RaycastHit hit;

    void Update()
    {
        if (Camera.main == null) return;

        Ray ray = new Ray(Camera.main.transform.position,
                          Camera.main.transform.forward);

        // 🔴 VISUAL DEBUG
        Debug.DrawRay(ray.origin, ray.direction * range, Color.red);

        bool isHit = Physics.Raycast(ray, out hit, range);

        if (isHit)
        {
            // create indicator once
            if (indicator == null)
                indicator = Instantiate(indicatorPrefab);

            indicator.SetActive(true);

            // ✅ FIX POSITION (IMPORTANT)
            indicator.transform.position = hit.point;

            // 🔵 keep flat on ground
            indicator.transform.up = hit.normal;
        }
        else
        {
            if (indicator != null)
                indicator.SetActive(false);
        }

        // 🖱️ teleport ONLY when valid hit
        if (isHit && Input.GetMouseButtonDown(0))
        {
            CharacterController cc = GetComponent<CharacterController>();

            cc.enabled = false;
            transform.position = hit.point + Vector3.up * 1f;
            cc.enabled = true;
        }
    }
}
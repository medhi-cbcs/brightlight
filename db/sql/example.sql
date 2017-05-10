SELECT a.State, count(c.CustomerID)
FROM Product p
INNER JOIN Customer c ON c.CustomerID = p.CustomerID
LEFT JOIN Address a ON a.CustomerID = c.CustomerID 
      AND a.AddressID = 
        (
           SELECT MAX(AddressID) 
           FROM Address z 
           WHERE z.CustomerID = a.CustomerID
        )
WHERE p.ProductID = 101
GROUP BY a.State
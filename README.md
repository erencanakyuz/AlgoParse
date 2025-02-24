

## 📌 Introduction  
This project implements **three compiler optimization algorithms** using **Lex & Yacc**:
1. **Constant Folding**  
2. **Copy or Constant Propagation**  
3. **Algebraic Simplification**  

Each algorithm is developed **individually** with separate Lex and Yacc files to avoid mixing functionalities. A **Makefile** is included for **compilation and execution** using `g++`. All sample inputs and outputs were tested successfully, and additional test cases were implemented for extra credit.

---

## 🔹 **Algorithms Overview**  
### **1️⃣ Constant Folding**  
- **Purpose:** Precomputes constant expressions at compile-time to optimize execution.  
- **Lexical Analysis:** Tokenizes numbers, variables, and operators.  
- **Syntax Analysis:** Evaluates constant expressions while preserving non-constant terms.  
- **Optimization:**  
  - Example: `a = 3 + 5;` → `a = 8;`  

### **2️⃣ Copy or Constant Propagation**  
- **Purpose:** Replaces redundant variables with assigned values.  
- **Lexical Analysis:** Defines tokens for arithmetic operations and assignments.  
- **Optimization:**  
  - Example:  
    ```c
    a = 4;  
    b = a + 2;  
    ```
    Transformed into:  
    ```c
    a = 4;  
    b = 4 + 2;  
    ```

### **3️⃣ Algebraic Simplification**  
- **Purpose:** Applies **mathematical identities** to simplify expressions.  
- **Optimization Rules:**  
  - `x + 0 → x`  
  - `x * 1 → x`  
  - `x * 0 → 0`  
  - `x ^ 2 → x * x`  
- **Example:**  
  ```c
  x = x + 0;   // Removed
  x = x * 1;   // Removed
  x = x * 0;   // x = 0;
  y = y ^ 2;   // y = y * y;
